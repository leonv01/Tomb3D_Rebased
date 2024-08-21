using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public interface IMovement
{
    float Speed { get; set; }
    float RunSpeed { get; set; }
    float JumpVelocity { get; set; }
}