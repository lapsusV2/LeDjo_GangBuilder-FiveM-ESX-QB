function sendNotify(title, description, type)
    lib.notify({
        title = title,
        description = description,
        duration = 4500,
        type = type,
        position = 'bottom'
    })
end


RegisterNetEvent('ledjo_gang:notify', sendNotify)