import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Thêm thư viện tính toán

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = "";
  String _output = "0";

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "AC") {
        _input = "";
        _output = "0";
      } else if (value == "=") {
        try {
          _output = _calculateResult(_input);
        } catch (e) {
          _output = "Error";
        }
      } else {
        _input += value;
        _output = _input; // Cập nhật màn hình ngay khi nhập
      }
    });
  }

  String _calculateResult(String input) {
    try {
      input = input.replaceAll("×", "*").replaceAll("÷", "/"); // Chuyển ký hiệu toán học về chuẩn
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      // Nếu kết quả là số nguyên, trả về dạng số nguyên, ngược lại trả về số thực
      return (result % 1 == 0) ? result.toInt().toString() : result.toString();
    } catch (e) {
      return "Error";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0, // Không có bóng
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Minh Hữu\nMinh Hoàng",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _input, // Hiển thị biểu thức nhập vào
                    style: TextStyle(color: Colors.white70, fontSize: 30),
                  ),
                  Text(
                    _output, // Hiển thị kết quả
                    style: TextStyle(color: Colors.white, fontSize: 60),
                  ),
                ],
              ),
            ),
          ),

          _buildButtonRow(["AC", "+/-", "%", "÷"], [Colors.grey, Colors.grey, Colors.grey, Colors.orange]),
          _buildButtonRow(["7", "8", "9", "×"], [Colors.grey[850]!, Colors.grey[850]!, Colors.grey[850]!, Colors.orange]),
          _buildButtonRow(["4", "5", "6", "-"], [Colors.grey[850]!, Colors.grey[850]!, Colors.grey[850]!, Colors.orange]),
          _buildButtonRow(["1", "2", "3", "+"], [Colors.grey[850]!, Colors.grey[850]!, Colors.grey[850]!, Colors.orange]),
          _buildButtonRow(["0", ".", "=", ""], [Colors.grey[850]!, Colors.grey[850]!, Colors.orange, Colors.black]),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> labels, List<Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(labels.length, (index) {
        return labels[index].isNotEmpty
            ? _buildButton(labels[index], colors[index])
            : SizedBox(width: 0);
      }),
    );
  }

  Widget _buildButton(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(label),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          backgroundColor: color,
          minimumSize: Size(80, 80),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
