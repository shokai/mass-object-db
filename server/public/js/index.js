var mass_range = 5;
var ws = null;
var ws_connect_timer = setInterval(function(){
    if(ws == null || ws.readyState != 1){
        ws = new WebSocket("ws://localhost:8080");
        ws.onmessage = function(e){
            console.log(e.data);
            display(new Number(e.data), mass_range);
        };
        ws.onclose = function(){
            $('#status').html("[websocket closed]");
        };
        ws.onopen = function(){
            $('#status').html("[ok]");
        };
    }
}, 5000);

$(function(){
    $('#status').html("[websocket connecting...]");
    display();
})

function display(mass, range){
    $('div#items h2').html('');
    var disp_items;
    if(mass > 0 && range > 0){
        disp_items = items.delete_if(function(i){
            if(mass+range >= i.mass && i.mass >= mass-range) return true;
            return false;
        });
        $('div#items h2').append(mass+'±'+range+'(g) - ');
    }
    else{
        disp_items = items;
    }
    $('div#items h2').append(disp_items.length+' items')
    var ul = $('ul#items').html('');
    for(var i = 0; i < disp_items.length; i++){
        var item = disp_items[i];
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
