// Based off of WhateverGreen's sample.dsl
// https://github.com/acidanthera/WhateverGreen/blob/master/Manual/Sample.dsl
DefinitionBlock ("", "SSDT", 2, "ACDT", "AMDGPU", 0x00001000)
{
    External (_SB_.PCI0, DeviceObj)
    External (_SB_.PCI0.GPP8.X161, DeviceObj)


    Scope (\_SB.PCI0.GPP8.X161)
    {
      
        Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
        {
          If (_OSI ("Darwin"))
          {
            Store (Package ()
            {
                // Where we shove our FakeID
                "device-id",
                Buffer (0x04)
                {
                    0x38, 0x69, 0x00, 0x00
                },

                // Changing the name of the GPU reported, mainly cosmetic
                "model",
                Buffer ()
                {
                    "AMD Radeon R9 380"
                }
                        
             }, Local0)
             DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
             Return (Local0)
           }
          Else
          {
               Return (Zero)
          }
        }
    }
    Scope (\_SB.PCI0)
    {                   
        Method (DTGP, 5, NotSerialized)
        {
            If (LEqual (Arg0, ToUUID ("a0b5b7c6-1318-441c-b0c9-fe695eaf949b")))
            {
                If (LEqual (Arg1, One))
                {
                    If (LEqual (Arg2, Zero))
                    {
                        Store (Buffer (One)
                            {
                                 0x03
                            }, Arg4)
                        Return (One)
                    }

                    If (LEqual (Arg2, One))
                    {
                        Return (One)
                    }
                }
            }

            Store (Buffer (One)
                {
                     0x00
                }, Arg4)
            Return (Zero)
        }
      
    }

}