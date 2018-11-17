-- | This module defines a restricted API to JavaScript's native object constructors
-- | which includes the `new` keyword, `Function.call`, and prototypical inheritance.

module Constructor where

import Prelude
-- import Record.Builder (Builder, build)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, mkEffectFn2, runEffectFn2, runEffectFn3)
import Unsafe.Coerce (unsafeCoerce)
import Prim.Row (class Union, class Nub, class Cons)
import Data.Symbol (SProxy, class IsSymbol, reflectSymbol)
import Type.Row (class RowToList, class ListToRow, Nil)


foreign import data Constructor :: Type -> Type -> # Type -> Type
foreign import data Instance :: # Type -> Type -- Union of inherited fields?
foreign import data This :: # Type -> Type

                                 -- FIXME this' set fields should be ()
foreign import mkConstructorImpl :: forall opts r
                                  . (EffectFn2 (This ()) opts (This r))
                                 -> Constructor Unit opts r
foreign import getThisImpl :: forall r a. EffectFn2 (This r) String a
foreign import insertThisImpl :: forall r r' a. EffectFn3 (This r) String a (This r')
foreign import modifyThisImpl :: forall r r' a. EffectFn3 (This r) String a (This r')

get :: forall l a r r'. Cons l a r' r => IsSymbol l => This r -> SProxy l -> Effect a
get t s = runEffectFn2 getThisImpl t (reflectSymbol s)

insert :: forall l a r r'. Cons l a r' r => IsSymbol l => This r -> SProxy l -> a -> Effect (This r')
insert t s x = runEffectFn3 insertThisImpl t (reflectSymbol s) x

modify :: forall l a r r'. Cons l a r' r => IsSymbol l => This r -> SProxy l -> (a -> a) -> Effect (This r)
modify t s f = runEffectFn3 modifyThisImpl t (reflectSymbol s) f

mkConstructor :: forall opts r
               . (This () -> opts -> Effect (This r)) -> Constructor Unit opts r
mkConstructor = mkConstructorImpl <<< mkEffectFn2


foreign import instanceOfImpl :: forall opts proto r r'. Instance r' -> Constructor proto opts r -> Boolean

foreign import hasOwnProperty :: forall r. Instance r -> String -> Boolean

-- foreign import apply1 :: forall r. 
--                call1
--                call2
--                call3 :: forall r. (a -> b -> c -> d) -> { | r } -> a -> b -> c -> ThisM d


-- foreign import getThisImpl :: forall r a. EffectFn2 (This r) String a

-- FIXME return a mock `this` with field added / set
-- foreign import setThisImpl :: forall r a. EffectFn3 (This r) String a Unit


class InheritedFields (x :: Type) (y :: # Type)
instance inheritedFieldsNil :: ListToRow Nil r => InheritedFields Unit r
instance inheritedFieldsCons :: ( InheritedFields proto acc
                                , Union acc r r'
                                ) => InheritedFields (Constructor props opts r) r'


foreign import newImpl :: forall proto opts r r'
                        . EffectFn2
                          (Constructor proto opts r)
                          opts
                          (Instance r')

new :: forall proto opts r r'
     . InheritedFields (Constructor proto opts r) r'
    => Constructor proto opts r
    -> opts
    -> Effect (Instance r')
new = runEffectFn2 newImpl

-- Consolidate all static declarations to avoid redefinitions?

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

-- FIXME return a builder, potentially?
-- foreign import setPrototypeFieldImpl :: forall opts r
--                                       . EffectFn3
--                                         (Constructor proto opts r)
--                                         String
--                                         (This r -> a) Unit

