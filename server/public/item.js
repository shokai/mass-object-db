
$(function(){
    display();
    $('input#delete').click(function(){
        $.ajax({
            type : 'DELETE',
            url : app_root+'/api/item/'+item.id+'.json',
            dataType : 'json',
            success : function(){location.href = app_root}
        });
    });
})

function display(){
    var sp_name = $('div#item div#name span.entity').html(item.name);
    var sp_mass = $('div#item div#mass span.entity').html(item.mass);
    var sp_img = $('div#item div#img span.img');
    if(item.img_url) sp_img.html($('<img />').attr('src',item.img_url));
    else sp_img.html('(no img)');
    
    var sp_img_url = $('div#item div#img span.entity').html(item.img_url);
    var url = gyazz_url+'/'+item.name;
    $('div#item div#url span.entity').html($('<a />').append(url).attr('href',url));

    var sp_name_edit = $('div#item div#name span.edit').html('[edit]');
    sp_name_edit.live('click', function(){
        sp_name_edit.html('').die('click');
        edit_item_param(sp_name, 'name', item.name);
    });
    var sp_mass_edit = $('div#item div#mass span.edit').html('[edit]');
    sp_mass_edit.live('click', function(){
        sp_mass_edit.html('').die('click');
        edit_item_param(sp_mass, 'mass', item.mass);
    });
    var sp_img_edit = $('div#item div#img span.edit').html('[edit]');
    sp_img_edit.live('click', function(){
        sp_img_edit.html('').die('click');
        edit_item_param(sp_img_url, 'img_url', item.img_url);
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