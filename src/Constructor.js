"use strict";

exports.mkConstructor = function mkConstructor(F) {
    return F(this);
};

exports.instanceOf = function instanceOfImpl1(obj) {
    return function instanceOfImpl2(Cons) {
        return obj instanceof Cons;
    };
};

exports.hasOwnProperty = function hasOwnProperty(o,l) {
    return o.hasOwnProperty(l);
};


exports.getThisImpl = function getThisImpl(this_,l) {
    return this_[l];
};

exports.setThisImpl = function setThisImpl(this_,l,x) {
    this_[l] = x;
};


exports.newImpl = function newImpl(Cons,opts) {
    return new Cons(opts);
};


exports.setPrototypeImpl = function setPrototypeImpl(Cons,x) {
    Cons.prototype = x;
};

exports.setPrototypeFieldImpl = function setPrototypeFieldImpl(Cons,l,x) {
    Cons.prototype[l] = x;
};
