
import unittest
import calculator

class TestCalculator(unittest.TestCase):  # a test case for the calculator.py module

    def test_add(self):
        # tests for the add() function
        self.assertEqual(calculator.add(6, 4), 10)
        self.assertEqual(calculator.add(6, -4), 2)
        self.assertEqual(calculator.add(-6, 4), -2)
        self.assertEqual(calculator.add(-6, -4), -10)

    def test_divide(self):
        # tests for the divide() function
        # ...
        with self.assertRaises(ValueError):
            calculator.divide(5, 0)