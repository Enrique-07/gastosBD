const String initDbScript = """
  CREATE TABLE Category (
      id INTEGER PRIMARY KEY,
      title TEXT,
      desc TEXT,
      iconCodePoint INTEGER
      );
    """;

  const String createExpenseDbScript = """
  CREATE TABLE Expense (
      id INTEGER PRIMARY KEY,
      categoryId INTEGER, 
      title TEXT,
      notes TEXT,
      amount REAL,
      FOREIGN KEY (categoryId)
      REFERENCES Category (id)
      );
    """;
  const String createIncomeDbScript = """
  CREATE TABLE Income (
      id INTEGER PRIMARY KEY,
      title TEXT,
      amount INTEGER 
      );
    """;

  const String createIncome2DbScript = """
  CREATE TABLE Income2 (
      id INTEGER PRIMARY KEY,
      title TEXT,
      amount INTEGER 
      );
    """;
