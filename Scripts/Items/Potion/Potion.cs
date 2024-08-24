using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public partial class Potion : Item
{
    protected override void OnItemPickedUp(Player player)
    {
        Logger.Log("Potion picked up!");
        base.OnItemPickedUp(player);
    }
}
