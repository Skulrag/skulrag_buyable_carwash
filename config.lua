Config = {}

-- Lang
Config.Locale = 'en'


-- Minimum price authorized to sell the car wash station (only concern owners)
Config.MinimumAuthorizedSellingPrice = 0


-- Time taken to clean the vehicle (in seconds)
Config.Timer = 20

-- Price multiplied by dirt level. There's 16 dirt levels, from 0 to 15. Price 10 means completely dirty car costs $150 to clean.
Config.Price = 10


-- Blips
Config.Blip = {
  Scale = 0.6
}

-- Markers configuration
Config.DrawDistance = 100.0

Config.Manage = {
  MarkerType = 21,
  MarkerColor = { r = 73, g = 51, b = 150 }
}

Config.Washer = {
  MarkerType = 27,
  MarkerColor = { r = 73, g = 51, b = 150 },
  BlipScale = 0.7
}


-- Carwash zones locations, there is two points per zone : the vehicle washer and carwash station managment
-- You can add as many stations as you want, /!\ REMEMBER TO ADAPT YOUR DATABASE TO IT /!\
Config.Zones = {
  PaletoBay = {
    Washer = {
      Size = { x = 3.0, y = 3.0, z = 3.0 },
      Pos = vector3(-224.55, 6251.38, 30.53)
    },
    Manage = {
      Size = { x = 1.0, y = 1.0, z = 1.0 },
      Pos = vector3(-223.37, 6243.26, 31.49)
    }
  },
  MiddleWest = {
    Washer = {
      Size = { x = 3.0, y = 3.0, z = 3.0 },
      Pos = vector3(-2554.69, 2346.86, 32.16)
    },
    Manage = {
      Size = { x = 1.0, y = 1.0, z = 1.0 },
      Pos = vector3(-2566.09, 2307.17, 33.22)
    }
  },
  Sandyshore = {
    Washer = {
      Size = { x = 3.0, y = 3.0, z = 3.0 },
      Pos = vector3(1058.72, 2656.78, 38.65)
    },
    Manage = {
      Size = { x = 1.0, y = 1.0, z = 1.0 },
      Pos = vector3(1048.49, 2653.26, 39.55)
    }
  },
  LSEast = {
    Washer = {
      Size = { x = 3.0, y = 3.0, z = 3.0 },
      Pos = vector3(1121.17, -779.93, 56.84)
    },
    Manage = {
      Size = { x = 1.0, y = 1.0, z = 1.0 },
      Pos = vector3(1130.11, -776.61, 57.61)
    }
  },
  LSNorth = {
    Washer = {
      Size = { x = 3.0, y = 3.0, z = 3.0 },
      Pos = vector3(-110.08, 37.39, 70.51)
    },
    Manage = {
      Size = { x = 1.0, y = 1.0, z = 1.0 },
      Pos = vector3(-105.93, 32.96, 71.43)
    }
  },
  LSWest = {
    Washer = {
      Size = { x = 3.0, y = 3.0, z = 3.0 },
      Pos = vector3(-699.78, -933.07, 18.11)
    },
    Manage = {
      Size = { x = 1.0, y = 1.0, z = 1.0 },
      Pos = vector3(-702.79, -916.99, 19.21)
    }
  },
  LSSouth = {
    Washer = {
      Size = { x = 3.0, y = 3.0, z = 1.0 },
      Pos = vector3(23.576, -1392.00, 28.43)
    },
    Manage = {
      Size = { x = 1.0, y = 1.0, z = 1.0 },
      Pos = vector3(9.11, -1394.51, 29.29)
    }
  }
}
