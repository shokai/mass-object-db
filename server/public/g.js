
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
        a_name = $('<a />').attr('href',gyazz_url+item.name).append(item.name);
        span_name = $('<span />').addClass('name').append(a_name);
        span_name.css('font-size',50-Math.abs(g-item.mass)*5);
        span_mass = $('<span />').addClass('mass').append(item.mass+' (g)');
        a_edit = $('<a />').attr('href',app_root+'/item/'+item.name).append('edit');
        span_edit = $('<span />').addClass('edit').append(a_edit);

        li.append(span_name);
        li.append(span_mass);
        li.append(span_edit);
        ul.append(li);
    }
    $('div#items').html(ul)
}

function Items(){
    this.load = function(mass, on_load){
        var uri = api+'?mass='+mass
        $.getJSON(uri, function(res){
            if(res.error == null){
                data = res;
                if(on_load != null) on_load();
            }
        });
    }
}