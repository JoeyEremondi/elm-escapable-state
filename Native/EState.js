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
        state.arr[refVal] = newValue;
        return makePair(state, null);
        
    }

    function newState(x)
    {
        return {next : 0, arr : [], ctor :  "_isEStateReference"};
    }

    function checkIfIsRef(x)
    {
        if (x._ctor = "_isEStateReference")
        {
            return {ctor : "True"};
        }
        return {ctor : "False"};
    }

    return localRuntime.Native.EState.values = {
        newRef : newRef,
        deRef   : deRef,
        writeRef  : writeRef,
        newState : newState,
        checkIfIsRef : checkIfIsRef
    };
};
