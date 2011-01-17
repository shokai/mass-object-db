
$(function(){
    display();
})

function display(){
    $('div#item span#name').html(item.name);
    $('div#item span#mass').html(item.mass);
    var url = gyazz_url+'/'+item.name;
    $('div#item span#url').append($('<a />').append(url).attr('href',url));
}