package thx.core;

import thx.core.Tuple;
using thx.core.Iterators;

/**
 * Helper methods for Maps
 */
class Maps {
    /**
     * Converts a Map<TKey, TValue> into an Array<Tuple2<TKey, TValue>>
     */
    public static function tuples<TKey, TValue>(map: Map<TKey, TValue>): Array<Tuple2<TKey, TValue>>
        return map.keys().map(function(key)
            return new Tuple2(key, map.get(key))
        );
}
