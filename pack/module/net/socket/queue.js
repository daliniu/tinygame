var Queue = function() {
    this.tail = [];
    this.head = [];
    this.offset = 0;
};

module.exports = Queue;

Queue.prototype.shift = function () {
    if (this.offset === this.head.length) {
        var tmp = this.head;
        tmp.length = 0;
        this.head = this.tail;
        this.tail = tmp;
        this.offset = 0;
        if (this.head.length === 0) {
            return;
        }
    }
    return this.head[this.offset++];
};

Queue.prototype.push = function (item) {
    return this.tail.push(item);
};

Queue.prototype.getLength = function () {
    return this.head.length - this.offset + this.tail.length;
};

Queue.prototype.first = function() {
    if (this.offset === this.head.length) {
        return this.tail[0];
    }
    return this.head[this.offset];
};
