package thx.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
using haxe.macro.TypeTools;
using haxe.macro.ExprTools;
using thx.macro.MacroFields;
using thx.core.Objects;
using thx.core.Arrays;
using StringTools;

class BuildResource {
	macro public static function buildStatic() : Array<Field> {
		var fields = Context.getBuildFields(),
				o = getResourceObject(Context.getLocalClass().get());
		return fields.concat(generateFieldsFromObjectLiteral(o));
	}

	static var formats = ["json" #if yaml , "yaml" #end];

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

	static function getResourceObject(cls : ClassType) {
		var o = {};
		Objects.merge(o, getContentMeta(cls.meta));
		Objects.merge(o, getMatchingFile(cls.name, cls.module, formats));
		Objects.merge(o, getContentFile(cls.meta, cls.module));
		return o;
	}

	static function getContentMeta(meta : MetaAccess) : {} {
		if(!meta.has(":content"))
			return {};
		var o = {};
		meta.extract(":content")
			.map(function(v) return v.params)
			.flatten()
			.map(function(p) return ExprTools.getValue(p))
			.map(function(n) Objects.merge(o, n));
		return o;
	}

	static function getMatchingFile(type : String, module : String, formats : Array<String>) {
		var path = Macros.getModulePath(module);
		if(null == path) return {};
		// strip extension
		path = path.split(".").slice(0, -1).join(".");
		// change file name
		path = path.replace("\\", "/").split("/").slice(0, -1).concat([type.split(".").pop()]).join("/");
		var list = formats
			.map(function(format) return '$path.$format')
			.filter(function(path) return sys.FileSystem.exists(path) && !sys.FileSystem.isDirectory(path))
			.map(function(path) return { file : path, format : null });
		return getFromFiles(list, module);
	}

	static function getContentFile(meta : MetaAccess, module : String) {
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
			module);
	}

	static function getFromFiles(list : Array<{ file : String, format : String }>, module : String) {
		var o = {};
		list.map(function(item) Objects.merge(o, getFromFile(item.file, module, item.format)));
		return o;
	}

	// TODO: add XML? Is anyone using that anymore?
	static function getFromFile(file : String, module : String, ?format : String) {
		if(null == format)
			format = file.split(".").pop();
		var content = sys.io.File.getContent(file);
		Context.registerModuleDependency(module, file);
		return switch format.toLowerCase() {
			case "json":
				haxe.Json.parse(content);
#if yaml
			case "yml", "yaml":
				var options = new yaml.Parser.ParserOptions();
				options.maps = false;
				yaml.Yaml.parse(content, options);
#end
			case _: Context.error('Invalid format $format', Context.currentPos());
		}
	}
}
