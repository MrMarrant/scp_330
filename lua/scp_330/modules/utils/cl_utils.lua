net.Receive(SCP_330_CONFIG.SetConvarClientSide, function ()
    local name = net.ReadString()
    local value = net.ReadUInt(14)
    SCP_330_CONFIG[name] = value
end)