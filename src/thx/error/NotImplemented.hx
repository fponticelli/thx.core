package thx.error;

import haxe.PosInfos;

/**
`NotImplemented` extends `Error` and it is intended to be used inside method
that are drafted but still do not provide an implementation.

```haxe
public function toBeDone() {
  throw new NotImplemented();
}
```
*/
class NotImplemented extends thx.Error {
  public function new(?posInfo : PosInfos)
    super('method ${posInfo.className}.${posInfo.methodName}() needs to be implemented', posInfo);
}