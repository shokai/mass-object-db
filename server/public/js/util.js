Array.prototype.delete_if = function(block){
    var res = new Array();
    for(var i = 0; i < this.length; i++){
        var item = this[i];
        if(block(item)) res.push(item);
    };
    return res;
};