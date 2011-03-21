
var mass_range = 5;
var ws = null;
var ws_connect_timer = setInterval(function(){
    if(ws == null || ws.readyState != 1){
        ws = new WebSocket("ws://localhost:8080");
        ws.onmessage = function(e){
            console.log(e.data);
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
    display();
})

function display(){
    $('div#items h2').html(items.length+' items')
    var ul = $('ul#items').html('');
    for(var i = 0; i < items.length; i++){
        var item = items[i];
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
