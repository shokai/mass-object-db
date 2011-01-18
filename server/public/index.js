
var data;
var items = new Items();
var mass_range = 5;

$(function(){
    items.load(display);
})


function display(){
    $('div#items h2').html(data.count+'個のアイテムが登録されています')
    var ul = $('ul#items').html('');
    for(var i = 0; i < data.count; i++){
        var item = data.items[i];
        var li = $('<li />').attr('id', item.id);
        var img = $('<img />').attr('src',item.img_url);
        var a_name = $('<a />').attr('href',gyazz_url+'/'+item.name).append(img).append(item.name);
        var span_name = $('<span />').addClass('name').append(a_name);
        var a_mass = $('<a />').attr('href',app_root+'/g/'+item.mass).append(item.mass+'(g)');
        var span_mass = $('<span />').addClass('mass').append(a_mass);
        var a_edit = $('<a />').attr('href',app_root+'/item/'+item.id).append('[edit]');
        var span_edit = $('<span />').addClass('edit').append(a_edit);

        li.append(span_name);
        li.append(span_mass);
        li.append(span_edit);
        ul.append(li);
    }
}

function Items(){
    this.load = function(on_load){
        var uri = app_root+'/api/items.json';
        $.getJSON(uri, function(res){
            if(res.error == null){
                data = res;
                if(on_load != null) on_load();
            }
        });
    };
}