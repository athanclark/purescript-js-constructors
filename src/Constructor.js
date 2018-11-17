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

exports.insertThisImpl = function insertThisImpl(this_,l,x) {
    var this__ = Object.create({},this_);
    this__[l] = x;
    return this__;
};

exports.modifyThisImpl = function modifyThisImpl(this_,l,f) {
    var this__ = Object.create({},this_);
    var x = this__[l];
    this__[l] = f(x);
    return this__;
};


exports.newImpl = function newImpl(Cons,opts) {
    return new Cons(opts);
};


exports.setPrototypeImpl = function setPrototypeImpl(Cons,x) {
    var Cons_ = Cons;
    Cons_.prototype = x;
    return Cons_;
};

exports.setPrototypeConstructorImpl = function setPrototypeConstructorImpl(Cons,Cons_) {
    Cons.prototype.constructor = Cons_;
};

exports.setPrototypeFieldImpl = function setPrototypeFieldImpl(Cons,l,x) {
    Cons.prototype[l] = x;
};
