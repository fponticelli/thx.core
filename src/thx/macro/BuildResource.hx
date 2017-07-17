package thx.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.ExprTools;
using thx.Objects;
using thx.Arrays;
using thx.Strings;

class BuildResource {
  macro public static function buildStatic() : Array<Field> {
    var fields = Context.getBuildFields(),
        o = getResourceObject(Context.getLocalClass().get());
    return generateFieldsFromObjectLiteral(o).concat(fields);
  }

  static var formats = ["json" #if yaml , "yaml" #end];
  static var prefixSymbol = "&";

  static function generateFieldsFromObjectLiteral(o : {}) : Array<Field> {
    return Objects.tuples(o).map(function(t) {
        var v = t.right,
            e = macro $v{v};
        return {
            pos : Context.currentPos(), // TODO improve
            name : t.left,
            meta : null,
            kind : FieldType.FVar(null, e),
            doc : null,
            access : [APublic, AStatic]
          };
      });
  }

  static function resolveReferences(o : {}, prefix : String, module : String, path : String) {
    if(null == prefix || !Reflect.isObject(o))
      return;
    var length = prefix.length;
    o.tuples().map(function(t) {
      if(t.left.startsWith(prefix)) {
        if(!Std.is(t.right, String))
          return;
        var key = t.left.substring(length),
            value : String = path.isEmpty() ? t.right : '$path/${t.right}',
            newvalue = getFromFile(value, module, prefix, true);
        Reflect.deleteField(o, t.left);
        Reflect.setField(o, key, newvalue);
      } else if(Reflect.isObject(t.right)) {
        resolveReferences(t.right, prefix, module, path);
      }
    });
  }

  static function resolvePrefix(meta : MetaAccess) : String {
    if(!meta.has(":resolve"))
      return null;
    var values = meta.extract(":resolve")
        .map(function(v) return v.params)
        .flatten()
        .map(function(p) return ExprTools.getValue(p));
    if(values.length == 0 || !Std.is(values[0], String))
      return prefixSymbol;
    return values[0];
  }

  static function getResourceObject(cls : ClassType) {
    var o = {},
        prefix = resolvePrefix(cls.meta);
    Objects.assign(o, getDirMeta(cls.meta, cls.module, prefix));
    Objects.assign(o, getContentMeta(cls.meta, cls.module, prefix));
    Objects.assign(o, getMatchingFile(cls.name, cls.module, formats, prefix));
    Objects.assign(o, getContentFile(cls.meta, cls.module, prefix));
    return o;
  }

  static function getContentMeta(meta : MetaAccess, module : String, prefix : String) : {} {
    if(!meta.has(":content"))
      return {};
    var o = {};
    meta.extract(":content")
      .map(function(v) return v.params)
      .flatten()
      .map(function(p) return ExprTools.getValue(p))
      .map(function(n) Objects.assign(o, n));
    var path = thx.macro.Macros.getModuleDirectory(module);
    resolveReferences(o, prefix, module, path);
    return o;
  }

  static function getDirMeta(meta : MetaAccess, module : String, prefix : String) : {} {
    if(!meta.has(":dir"))
      return {};
    var out = meta.extract(":dir")
      .map(function(v) return v.params)
      .flatten()
      .map(function(p) return ExprTools.getValue(p))
      .map(function(path) return getFromDir(Std.string(path), module, prefix))
      .reduce(function(acc, o) return Objects.assign(acc, o), {});
    return out;
  }

  static function getFromDir(dir : String, module : String, prefix : String) {
    var ob = {};
    for(path in sys.FileSystem.readDirectory(dir)) {
      if(path.startsWith(".")) continue; // ignore hidden files
      var fullPath = '$dir/$path',
          name = normalizeName(path);
      if(sys.FileSystem.isDirectory(fullPath)) {
        setField(ob, name, getFromDir(fullPath, module, prefix));
      } else {
        setField(ob, name, getFromFile(fullPath, module, prefix, null, true));
      }
    }
    return ob;
  }

  static function normalizeName(s : String) {
    var parts = s.split(".");
    if(parts.length > 1)
      parts.pop();
    return Strings.capitalizeWords(parts.join(" ")).lowerCaseFirst();
  }

  static function getMatchingFile(type : String, module : String, formats : Array<String>, prefix : String) {
    var path = Macros.getModulePath(module);
    if(null == path) return {};
    // strip extension
    path = path.split(".").slice(0, -1).join(".");
    // change file name
    path = path.replace("\\", "/").split("/").slice(0, -1).concat([type.split(".").pop()]).join("/");
    var list = formats
      .map(function(format) return './$path.$format')
      .filter(function(path) {
        // lower case file name
        var lc = path.split("/").slice(0, -1).concat([path.split("/").pop().toLowerCase()]).join("/");
        return (sys.FileSystem.exists(path) && !sys.FileSystem.isDirectory(path)) || (sys.FileSystem.exists(lc) && !sys.FileSystem.isDirectory(lc));
      })
      .map(function(path) return { file : path, format : null });
    return getFromFiles(list, module, prefix);
  }

  static function getContentFile(meta : MetaAccess, module : String, prefix : String) {
    return getFromFiles(
      formats
        .map(function(f) return { format : f, meta : ':$f'})
        .concat([{ format : null, meta : ":file"}])
        .map(function(des)
          return
            !meta.has(des.meta) ?
              [] :
              meta.extract(des.meta)
                .map(function(v) return v.params)
                .flatten()
                .map(function(p) return ExprTools.getValue(p))
                .map(function(file) return { file : file, format : des.format })
        )
        .flatten()
        .filter(function(item) return item != null),
      module,
      prefix);
  }

  static function setField(o : {}, field : String, value : Dynamic) {
    if(Reflect.hasField(o, field))
      throw 'duplicate key $field';
    Reflect.setField(o, field, value);
    return o;
  }

  static function getFromFiles(list : Array<{ file : String, format : String }>, module : String, prefix : String) {
    var o = {};
    list.map(function(item) Objects.assign(o, getFromFile(item.file, module, prefix, item.format, false)));
    return o;
  }

  // TODO: add XML? Is anyone using that anymore?
  static function getFromFile(file : String, module : String, prefix : String, ?format : String, ?allowText : Bool = false) : Dynamic {
    if(null == format)
      format = file.split(".").pop();
    var content : String = sys.io.File.getContent(file);
    Context.registerModuleDependency(module, file);
    var o = switch format.toLowerCase() {
      case "json":
        (haxe.Json.parse(content) : Dynamic);
#if yaml
      case "yml", "yaml":
        var options = new yaml.Parser.ParserOptions();
        options.maps = false;
        yaml.Yaml.parse(content, options);
#end
      case _:
        if(allowText)
          content;
        else
          Context.error('Invalid format $format', Context.currentPos());
    };
    resolveReferences(o, prefix, module, file.split("/").slice(0, -1).join("/"));
    return o;
  }
}
