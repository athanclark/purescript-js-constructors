-- | This module defines a restricted API to JavaScript's native object constructors
-- | which includes the `new` keyword, `Function.call`, and prototypical inheritance.

module Constructor where

import Prelude
import Record.Builder (Builder, build)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, mkEffectFn2)
import Unsafe.Coerce (unsafeCoerce)
import Prim.Row (class Union, class Nub)


foreign import data Constructor :: Type -> Type -> # Type -> Type
foreign import data Instance :: # Type -> Type -- Union of inherited fields?
foreign import data This :: # Type -> Type

                                -- FIXME this' set fields should be ()
foreign import mkConstructorImpl :: forall opts r
                                  . (EffectFn2 (This ()) opts (This r)) -> Constructor Unit opts r

mkConstructor :: forall opts r. (opts -> Effect (Builder {} { | r})) -> Constructor Unit opts r
mkConstructor f =
  let f' :: (This ()) -> opts -> Effect (This r)
      f' this' opts = do
        builder <- f opts
        pure $ unsafeCoerce $ build builder $ unsafeCoerce this'
  in  mkConstructorImpl (mkEffectFn2 f')


foreign import instanceOf :: forall opts proto r r'. Instance r' -> Constructor proto opts r -> Boolean

foreign import hasOwnProperty :: forall r. Instance r -> String -> Boolean

-- foreign import apply1 :: forall r. 
--                call1
--                call2
--                call3 :: forall r. (a -> b -> c -> d) -> { | r } -> a -> b -> c -> ThisM d


-- foreign import getThisImpl :: forall r a. EffectFn2 (This r) String a

-- FIXME return a mock `this` with field added / set
-- foreign import setThisImpl :: forall r a. EffectFn3 (This r) String a Unit


class InheritedFields (x :: Type) (y :: # Type)
instance inheritedFieldsNil :: InheritedFields (Constructor Unit opts r) r
-- instance inheritedFieldsCons :: ( InheritedFields proto acc
--                                 , Union acc r r'
--                                 ) => InheritedFields (Constructor props opts r) r'


foreign import newImpl :: forall proto opts r r'
                        . EffectFn2
                          (Constructor proto opts r)
                          opts
                          (Instance r')

foreign import setPrototypeImpl :: forall proto' proto opts r
                                 . EffectFn2
                                   (Constructor proto' opts r)
                                   (Instance proto)
                                   (Constructor (Instance proto) opts r)

foreign import setPrototypeConstructorImpl :: forall proto opts proto' opts' r r'
                                            . EffectFn2
                                              (Constructor proto opts r)
                                              (Constructor proto' opts' r')
                                              Unit

-- foreign import setPrototypeFieldImpl :: forall opts r
--                                       . EffectFn3
--                                         (Constructor proto opts r)
--                                         String
--                                         (This r -> a) Unit

