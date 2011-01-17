
var data;
var items = new Items();
var mass_range = 5;

$(function(){
    items.load(display);
    $('div#new_item input#btn_add').click(items.add);
})


function display(){
    var ul = $('ul#items');
    ul.html('');
    for(var i = 0; i < data.count; i++){
        var item = data.items[i];
        var li = $('<li />').attr('id', item.id);
        var a_name = $('<a />').attr('href',gyazz_url+'/'+item.name).append(item.name);
        var span_name = $('<span />').addClass('name').append(a_name);
        span_name.css('font-size', (70+(mass_range-Math.abs(item.mass-g))*40)+'%');
        var span_mass = $('<span />').addClass('mass').append(item.mass+' (g)');
        var a_edit = $('<a />').attr('href',app_root+'/item/'+item.id).append('edit');
        var span_edit = $('<span />').addClass('edit').append(a_edit);

        li.append(span_name);
        li.append(span_mass);
        li.append(span_edit);
        ul.append(li);
    }
}

function Items(){
    this.add = function(){
        console.log('add');
        var uri = app_root+'/api/item.json';
        var post_data = {'name' : $('div#new_item input#name').val(),
                         'mass' : g};
        $.post(uri, post_data, function(res){
            if(res.error == null) items.load(display);
        }, 'json');
    };
    
    this.load = function(on_load){
        var uri = app_root+'/api/items.json'
            + '?mass='+g+'&range='+mass_range;
        $.getJSON(uri, function(res){
            if(res.error == null){
                data = res;
                if(on_load != null) on_load();
            }
        });
    };
}