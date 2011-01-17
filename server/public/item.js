
$(function(){
    display();
})

function display(){
    var sp_name = $('div#item span#name').html(item.name);
    var sp_mass = $('div#item span#mass').html(item.mass);
    var url = gyazz_url+'/'+item.name;
    $('div#item span#url').html($('<a />').append(url).attr('href',url));

    sp_name.live('dblclick', function(){
        edit_item_param(sp_name, 'name', item.name);
    });
    sp_mass.live('dblclick', function(){
        edit_item_param(sp_mass, 'mass', item.mass);
    });
}

function edit_item_param(dom, name, default_val){
    dom.die('dblclick');
    var input = $('<input />').attr('id', name).attr('size', 30).attr('value', default_val);
    var btn = $('<input />').attr('type', 'button').attr('value', '保存');
    dom.html(input).append(btn);
    btn.click(function(e){
        put_item(name, $('input#'+name).val(), reload);
    });
}

function put_item(name, value, on_put){
    eval('post_data = { '+name+' : "'+value+'" };');
    $.ajax({
        type : 'PUT',
        url : app_root+'/api/item/'+item.id+'.json',
        data : post_data,
        dataType : 'json',
        success : on_put
    });
}

function reload(){
    var uri = app_root+'/api/item/'+item.id+'.json'
    $.getJSON(uri, function(res){
        if(res.error == null) item = res;
        display();
    });

}