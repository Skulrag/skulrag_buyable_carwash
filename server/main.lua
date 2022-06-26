local Carwash = {}
local ESX = nil
local QBCore = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

--
RegisterServerEvent('buyable_carwash:getOwners')
AddEventHandler('buyable_carwash:getOwners', function()
    local _source = source
    local cwListResult = MySQL.Sync.fetchAll('SELECT * FROM `carwash_list`')
    for i = 1, #cwListResult, 1 do
        Carwash[cwListResult[i].name] = {
            name = cwListResult[i].name,
            owner = cwListResult[i].owner,
            price = cwListResult[i].price,
            isForSale = cwListResult[i].isForSale
        }
    end

    local xPlayer = nil
    xPlayer = ESX.GetPlayerFromId(_source)    
    if xPlayer ~= nil then
        TriggerClientEvent('buyable_carwash:saveOwners', _source, Carwash, xPlayer.identifier)
    else
        TriggerClientEvent('esx:showNotification', _source, _U('comeback'))
    end
end)

RegisterServerEvent('buyable_carwash:openMenu')
AddEventHandler('buyable_carwash:openMenu', function(zone)
  TriggerClientEvent('buyable_carwash:menuIsAlreadyOpened', -1, zone, true)
end)

RegisterServerEvent('buyable_carwash:closeMenu')
AddEventHandler('buyable_carwash:closeMenu', function(zone)
  TriggerClientEvent('buyable_carwash:menuIsAlreadyOpened', -1, zone, false)
end)

--
RegisterServerEvent('buyable_carwash:buy_carwash')
AddEventHandler('buyable_carwash:buy_carwash', function(zone)
    local _source = source
    local xPlayer
    local playerMoney
    local xOwner
    local identifier

    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    playerMoney = xPlayer.getMoney()
    if Carwash[zone].owner ~= nil then
      xOwner = ESX.GetPlayerFromIdentifier(Carwash[zone].owner)
    end

    local price = MySQL.Sync.fetchScalar('SELECT price from `carwash_list` WHERE name=@zone', {
        ['@zone'] = zone,
    }, function(_)end)

    if playerMoney >= price then
        MySQL.Sync.execute('UPDATE `carwash_list` SET `price`=0, `owner`=@identifier, `isForSale`=@forsale WHERE name = @zone', {
            ['@identifier'] = identifier,
            ['@forsale'] = false,
            ['@zone'] = zone,
        }, function(_)end)

        xPlayer.removeMoney(tonumber(price))
        TriggerClientEvent('buyable_carwash:carwashBought', -1, zone, identifier)
        if xOwner ~= nil then
            xOwner.addAccountMoney('bank', price)
        end
        print(('[Carwash bought] FROM : Owner Identifier: %s /  BY : Identifier: %s'):format(Carwash[zone].owner, identifier))
        TriggerClientEvent('esx:showNotification', _source, _U('bought', price))
    else
        TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
    end
end)

--
RegisterServerEvent('buyable_carwash:withdrawMoney')
AddEventHandler('buyable_carwash:withdrawMoney', function(zone, amount)
  local _source = source
  local xPlayer  
  local identifier

    xPlayer = ESX.GetPlayerFromId(_source)
    identifier = xPlayer.identifier
    amount = ESX.Math.Round(tonumber(amount))

  local accountMoney = MySQL.Sync.fetchScalar('SELECT accountMoney from `carwash_list` WHERE name=@zone AND owner=@owner', {
      ['@owner'] = identifier,
      ['@zone'] = zone,
  }, function(_)end)
  if amount > 0 and accountMoney >= amount then
    local newAmount = accountMoney - amount
    MySQL.Sync.execute('UPDATE `carwash_list` SET `accountMoney`=@newAmount WHERE name = @zone', {
        ['@newAmount'] = newAmount,
        ['@zone'] = zone,
    }, function(_)end)
    xPlayer.addAccountMoney('bank', amount)
    print(('[Carwash withdrawMoney] BY : Owner Identifier: %s / Quantity : %d'):format(identifier, amount))
    
    TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)))
  else
    TriggerClientEvent('esx:showNotification', _source, _U('invalid_amount'))
  end
end)

-- Callbacks

    ESX.RegisterServerCallback('buyable_carwash:getAccountMoney', function(source, cb, zone)
        local accountMoney = MySQL.Sync.fetchScalar('SELECT accountMoney from `carwash_list` WHERE name=@zone', {
          ['@zone'] = zone,
      }, function(_)end)
      cb(accountMoney)
    end)

    ESX.RegisterServerCallback('buyable_carwash:isforsale', function(source, cb, zone)
      local price = MySQL.Sync.fetchScalar('SELECT price from `carwash_list` WHERE name=@zone', {
          ['@zone'] = zone,
      }, function(_)end)
      cb(Carwash[zone].isForSale, price)
    end)

    --
RegisterServerEvent('buyable_carwash:cancelselling')
AddEventHandler('buyable_carwash:cancelselling', function(zone)
    Carwash[zone].isForSale = false
    MySQL.Sync.execute('UPDATE `carwash_list` SET `isForSale`=@forsale WHERE name = @zone', {
        ['@forsale'] = false,
        ['@zone'] = zone,
    }, function(_)
    end)
    TriggerClientEvent('buyable_carwash:cancelSelling', -1, zone)
end)

--
RegisterServerEvent('buyable_carwash:putforsale')
AddEventHandler('buyable_carwash:putforsale', function(zone, price)
    Carwash[zone].isForSale = true
    MySQL.Sync.execute('UPDATE `carwash_list` SET `isForSale`=@forsale, `price`=@price WHERE name = @zone', {
        ['@forsale'] = true,
        ['@zone'] = zone,
        ['@price'] = price
    }, function(_)
    end)
    TriggerClientEvent('buyable_carwash:carwashForSale', -1, zone)
end)

function addMoneyToCarWash(zone, price)
  local accountMoney = MySQL.Sync.fetchScalar('SELECT accountMoney from `carwash_list` WHERE name=@zone', {
      ['@zone'] = zone
  }, function(_)end)
  MySQL.Sync.execute('UPDATE `carwash_list` SET `accountMoney`=@newAmount WHERE name = @zone', {
      ['@newAmount'] = accountMoney + price,
      ['@zone'] = zone,
  }, function(_)end)
end

RegisterServerEvent('buyable_carwash:checkMoney')
AddEventHandler('buyable_carwash:checkMoney', function(price, zone)
    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)
    price = tonumber(price)
    if price < xPlayer.getAccount('bank').money then
      TriggerClientEvent('buyable_carwash:clean', _source)
      xPlayer.removeAccountMoney('bank', price)
      addMoneyToCarWash(zone, price)
    elseif price < xPlayer.getMoney() then
        TriggerClientEvent('buyable_carwash:clean', _source)
        xPlayer.removeMoney(price)
        addMoneyToCarWash(zone, price)
    elseif price < xPlayer.getAccount('bank').money + xPlayer.getMoney() then
        TriggerClientEvent('buyable_carwash:clean', _source)
        local bankPrice = xPlayer.getAccount('bank').money
        xPlayer.removeAccountMoney('bank', bankPrice)
        local cashPrice = price - bankPrice
        xPlayer.removeMoney(cashPrice)
        addMoneyToCarWash(zone, price)
    else
        TriggerClientEvent('buyable_carwash:cancel', _source)
    end
end)
