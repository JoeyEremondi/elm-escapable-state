Elm.Native.EState = {};
Elm.Native.EState.make = function(localRuntime) {
    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.EState = localRuntime.Native.EState || {};
    if (localRuntime.Native.EState.values) 
    {
        return localRuntime.Native.EState.values;
    }


    function makePair(i,j)
    {
        return {ctor: "_Tuple2", _0 : i, _1:j};
    }

    function newRef(pair)
    {
        var initialValue = pair._0;
        var state = pair._1;
        var retVal = state.next;
        state.arr[retVal] = initialValue;
        state.next += 1;
        return makePair(state, retVal);
    }

    function deRef(pair)
    {
        var refVal = pair._0;
        var state = pair._1;
        return makePair(state, state.arr[refVal]);
    }

    function writeRef(triple)
    {
        var refVal = triple._0;
        var newValue = triple._1;
        var state = triple._2;
        var oldVal = state.arr[refVal];
        state.arr[refVal] = newValue;
        return makePair(state, oldVal);
        
    }

    function newArray(args)
    {
        var initialValue = args._0;
        var lower = args._1;
        var upper = args._2;
        var state = args._3;
        
        var retVal = state.next;
        state.arr[retVal] = [];
        for (i = lower; i <= upper; i++)
        {
            state.arr[retVal][i] = initialValue;
        }
        state.next += 1;
        return makePair(state, retVal);
    }

    function arrayElement(args)
    {
        var refVal = args._0;
        var i = args._1;
        var state = args._2;
        return makePair(state, state.arr[refVal][i]);
    }

    function writeArray(args)
    {
        var refVal = args._0;
        var newValue = args._1;
        var i = args._2;
        var state = args._3;
        var oldVal = state.arr[refVal][i];
        state.arr[refVal][i] = newValue;
        return makePair(state, oldVal);
        
    }

    function newState(x)
    {
        return {next : 0, arr : [], ctor :  "_isEStateReference"};
    }

    function checkIfIsRef(x)
    {
        if (typeof(x) == 'object' && x._ctor == "_isEStateReference")
        {
            return true;
        }
        return false;
    }

    return localRuntime.Native.EState.values = {
        newRef : newRef,
        deRef   : deRef,
        writeRef  : writeRef,
        newState : newState,
        checkIfIsRef : checkIfIsRef,
        newArray : newArray,
        writeArray : writeArray,
        arrayElement : arrayElement
    };
};
