import qibo
from qibo import gates
from qibo.models import Circuit
import numpy as np
from src.config import logger
from qilimanjaroq.circuit import RemoteCircuit


class TestQibo():

    def execute_circuit(self) -> dict:

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
        logger.info(f"Result state: {result.state()}")
        # print(c.summary())
        ts = result.state().tostring()
        print(np.fromstring(ts, dtype=int))
        return {"success": "OK"}

    def execute_qili_circuit(self) -> dict:
        qibo.set_backend('qilimanjaroq')
        # Construct the circuit
        c = RemoteCircuit(2)
        # Add some gates
        c.add(gates.H(0))
        c.add(gates.H(1))
        result = c.local_execute()

        print(result)
        print(result.state())
        logger.info(f"Result state: {result.state()}")
        # print(c.summary())
        ts = result.state().tostring()
        print(np.fromstring(ts, dtype=int))
        return {"success": "QILI OK!!!"}
