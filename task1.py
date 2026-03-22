import sys
import os
import argparse

from gem5.components.boards.simple_board import SimpleBoard  # type: ignore
from gem5.components.memory import SingleChannelDDR3_1600  # type: ignore
from gem5.components.cachehierarchies.classic.private_l1_cache_hierarchy import PrivateL1CacheHierarchy
from gem5.simulate.simulator import Simulator  # type: ignore
from gem5.resources.resource import CustomResource  # type: ignore

current_folder = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(current_folder, 'default'))

# Zdaj ju lahko varno uvozimo
from cpuInORD_model import RiscV_InOrder_CPU # type: ignore
from cpuO3_model import RISCV_O3_CPU # type: ignore
# --------------------------------

parser = argparse.ArgumentParser()
parser.add_argument("--cpu", choices=["minor", "o3"], required=True)
args = parser.parse_args()

# Izbira procesorja
processor = RiscV_InOrder_CPU() if args.cpu == "minor" else RISCV_O3_CPU()

cache_hierarchy = PrivateL1CacheHierarchy(l1d_size="64KiB", l1i_size="64KiB")
memory = SingleChannelDDR3_1600("7GiB")

# Sestava računalnika (Board)
board = SimpleBoard(
    clk_freq="3GHz",
    processor=processor,
    memory=memory,
    cache_hierarchy=cache_hierarchy
)

# 3. Z absolutno potjo določimo program, ki se bo izvajal (znotraj mape workload)
pot_do_binarne = os.path.join(current_folder, "workload", "scaled_dot_product_adv.bin")
binary = CustomResource(pot_do_binarne)

board.set_se_binary_workload(binary)

# Priprava in zagon simulatorja
print(f"Zaganjam simulacijo s procesorjem: {args.cpu} ...")
simulator = Simulator(board=board)
simulator.run()