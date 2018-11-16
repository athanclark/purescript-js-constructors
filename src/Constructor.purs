module Constructor where

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3)
import Unsafe.Coerce


foreign import Constructor :: Type -> Type -> # Type -> Type

foreign import This :: # Type -> Type

                                -- FIXME this' set fields should be ()
foreign import mkConstructor :: (This r -> opts -> Effect Unit) -> Constructor proto opts r


foreign import instanceOf :: forall opts r. { | r } -> Constructor proto opts r -> Boolean

foreign import hasOwnProperty :: forall r. { | r } -> String -> Boolean

foreign import apply1 :: forall r. 
               call1
               call2
               call3 :: forall r. (a -> b -> c -> d) -> { | r } -> a -> b -> c -> ThisM d


foreign import getThisImpl :: forall r a. EffectFn2 (This r) String a

-- FIXME return a mock `this` with field added / set
foreign import setThisImpl :: forall r a. EffectFn3 (This r) String a Unit



foreign import newImpl :: forall proto opts r. EffectFn2 (Constructor proto opts r) opts { | r }

foreign import setPrototypeImpl :: forall proto opts r. EffectFn2 (Constructor proto opts r) { | proto } Unit

foreign import setPrototypeConstructorImpl :: forall proto opts proto' opts' r r'
                                            . EffectFn2 (Constructor props opts r) (Constructor props' opts' r') Unit

foreign import setPrototypeFieldImpl :: forall opts r. EffectFn3 (Constructor proto opts r) String (This r -> a) Unit

