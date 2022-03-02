AddEventHandler('hintTriggered', function(resource, hintData)
    exports.bulletin:Send(hintData.text)
end)

AddEventHandler('hintsToggled', function(toggle)
    print(toggle and 'Ativado' or 'Desativado')
end)