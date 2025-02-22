--!strict

type Callback<C> = (C) -> ...any
type Object<T> = T

return function<T, C>(callback: Callback<C>, object: Object<T>)
    return setmetatable(object, {
        __call = function(_, ...)
            local args = { ... }
            return callback(unpack(args))
        end,
    })
end :: <T, C>(callback: (C) -> ...any, object: T) -> (C) -> T
