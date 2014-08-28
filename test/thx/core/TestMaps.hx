package thx.core;

import utest.Assert;

class TestMaps
{
    public function new() { }

    public function testTuples()
    {
        var map = [
            "key1" => 1,
            "key2" => 2
        ];

        var tuples = Maps.tuples(map);

        Assert.equals(2, tuples.length);
        Assert.equals(tuples[0]._0, "key1");
        Assert.equals(tuples[0]._1, 1);
        Assert.equals(tuples[1]._0, "key2");
        Assert.equals(tuples[1]._1, 2);
    }
}
