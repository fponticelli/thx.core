package thx.error;

import haxe.PosInfos;

/**
`AbstractMethod` extends `Error` and it is intended to be used inside those methods
that are considered abstract. Abstract methods are methods that needs to be implemented
in a sub-class.

The error message brings the class name/method name that is abstract.

```haxe
function abstractMethod() {
  throw new AbstractMethod();
}
```
*/
class AbstractMethod extends thx.Error {
  public function new(?posInfo : PosInfos)
    super('method ${posInfo.className}.${posInfo.methodName}() is abstract', posInfo);
}