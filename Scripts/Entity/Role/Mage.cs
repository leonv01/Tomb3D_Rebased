using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public class Mage : Role
{
    public override void Attack()
    {
        Logger.Log("Mage Attack");
    }

    public override void Block()
    {
        Logger.Log("Mage Block");
    }

    public override void Cast()
    {
        Logger.Log("Mage Cast");
    }

    public override void Dodge()
    {
        Logger.Log("Mage Dodge");
    }
}