from qibo import gates
from qibo.models import Circuit
import numpy as np

# Construct the circuit
c = Circuit(2)
# Add some gates
c.add(gates.H(0))
c.add(gates.H(1))
# Define an initial state (optional - default initial state is |00>)
initial_state = np.ones(4) / 2.0
# Execute the circuit and obtain the final state
# result = c(initial_state)  # c.execute(initial_state) also works
result = c.execute(initial_state)
print(result)
print(result.state())
# print(c.summary())
