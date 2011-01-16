
var data;
var items = new Items();

$(function(){
    items.load(g, display);
})


function display(){
    ul = $('<ul />');
    for(var i = 0; i < data.count; i++){
        item = data.items[i];
        li = $('<li />').attr('id', item.id);
        span_name = $('<span />').addClass('name').append(item.name);
        span_mass = $('<span />').addClass('mass').append(item.mass+' (g)');
        li.append(span_name);
        li.append(span_mass);
        ul.append(li);
    }
    $('div#items').html(ul)
}

function Items(){
    this.load = function(mass, on_load){
        var uri = api+'?mass='+mass
        $.getJSON(api, function(res){
            if(res.error == null){
                data = res;
                if(on_load != null) on_load();
            }
        });
    }
}