ENT.Base = "rx_printer_base"


-- Sounds
-- if you dont want to play sound, set true to false. the number is repeat time
ENT.ErrorSound = {true,1,"Resource/warning.wav"}
ENT.RuningSound = {true,8,"ambient/machines/machine6.wav"}

-- Main
ENT.PrinterMasterColor = Color(209, 183, 52,255)
ENT.PrinterName = "Золотой принтер"
ENT.PrinterHealth = 100
ENT.MaxMoney = 20000 -- How much money printer can hold?

-- Speed
ENT.SequenceMultiple = 50 -- More Higher, More faster printing animations. Just for animation.
ENT.RPM = 10 -- More Higher, More faster money creating. So generates 10 money for 1 second.
ENT.Hull = 5000 -- This printer can make money 100 times. after that, will be exploded. So 50 RPM x 300 Hull = Make 15000 $


-- Random BreakDown : Owner Should press E on printer to fix it. If not, printer will stop so no money. and will be exploded.
ENT.BreakDownTimer = 180 -- for every 100 seconds,
ENT.BreakDownRate = 0 -- BreakDown. for 30% chance. if you dont want it, set to 0
ENT.BreakDownDestoryTime = 30 -- Printer will be exploded if owner ignore the printer for 100 seconds.