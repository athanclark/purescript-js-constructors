"use strict";

exports.mkConstructorImpl = function mkConstructorImpl(f) {
    return function Cons (opts) {
        this = f(this,opts);
    };
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

exports.setPrototypeConstructorImpl = function setPrototypeConstructorImpl(Cons,Cons_) {
    Cons.prototype.constructor = Cons_;
};

exports.setPrototypeFieldImpl = function setPrototypeFieldImpl(Cons,l,x) {
    Cons.prototype[l] = x;
};
