window.addEventListener('message', function (event) {
    switch(event.data.action) {
        case 'notif':
            DoHudText(event.data);
            break;
    }
});

function DoHudText(data) {
    var $notification = $('.notification.template').clone();
    $notification.removeClass('template');
    $notification.addClass(data.type);
    $notification.html(escapeUnsafeString(data.text));
    $notification.fadeIn();
    $('.notif-container').append($notification);
    setTimeout(function() {
        $.when($notification.fadeOut()).done(function() {
            $notification.remove()
        });
    }, 7500);
}

function escapeUnsafeString(unsafe = "") {
    return new String(unsafe).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#039;");
}