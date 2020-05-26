ENT.Base = "rx_printer_base"


-- Sounds
-- if you dont want to play sound, set true to false. the number is repeat time
ENT.ErrorSound = {true,1,"Resource/warning.wav"}
ENT.RuningSound = {true,8,"ambient/machines/machine6.wav"}

-- Main
ENT.PrinterMasterColor = Color(155,155,155,255)
ENT.PrinterName = "Серебряный принтер"
ENT.PrinterHealth = 100
ENT.MaxMoney = 10000 -- How much money printer can hold?

-- Speed
ENT.SequenceMultiple = 25 -- More Higher, More faster printing animations. Just for animation.
ENT.RPM = 8 -- More Higher, More faster money creating. So generates 20 money for 1 second.
ENT.Hull = 3000 -- This printer can make money 100 times. after that, will be exploded. So 20 RPM x 250 Hull = Make 5000 $


-- Random BreakDown : Owner Should press E on printer to fix it. If not, printer will stop so no money. and will be exploded.
ENT.BreakDownTimer = 120 -- for every 100 seconds,
ENT.BreakDownRate = 0 -- BreakDown. for 30% chance. if you dont want it, set to 0
ENT.BreakDownDestoryTime = 20 -- Printer will be exploded if owner ignore the printer for 100 seconds.