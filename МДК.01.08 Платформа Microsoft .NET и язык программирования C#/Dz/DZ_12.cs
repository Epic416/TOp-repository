namespace Program
{
    internal class Program
    {
        static void DrawField(List<List<char>> field)
        {
            Console.Clear();
            for (int i = 0; i < 25; i++)
            {
                for (int j = 0; j < 25; j++)
                {
                    if (field[i][j] == '#')
                    {
                        Console.BackgroundColor = ConsoleColor.Red;
                    }
                    else if (field[i][j] == '*')
                    {
                        Console.BackgroundColor = ConsoleColor.Blue;
                    }
                    else if (field[i][j] == ' ')
                    {
                        Console.BackgroundColor = ConsoleColor.White;
                    }
                    else if (field[i][j] == 'x')
                    {
                        Console.BackgroundColor = ConsoleColor.Green;
                    }
                    Console.Write(" ");
                    Console.BackgroundColor = ConsoleColor.Black;
                }
                Console.WriteLine();
            }
        }

        static List<List<char>> CreateField()
        {
            List<List<char>> field = new List<List<char>>();

            for (int i = 0; i < 25; i++)
            {
                field.Add(new List<char>());
                for (int j = 0; j < 25; j++)
                {
                    if (i == 0 || i == 24)
                    {
                        field[i].Add('#');
                    }
                    else if (j == 0 || j == 24)
                    {
                        field[i].Add('#');
                    }
                    else
                    {
                        field[i].Add(' ');
                    }
                }
            }
            return field;
        }

        static void Main(string[] args)
        {
            Console.ForegroundColor = ConsoleColor.Green;
            Console.BackgroundColor = ConsoleColor.Yellow;

            List<List<char>> filed = CreateField();

            Random random = new Random();
            int appleX = random.Next(2, 24);
            int appleY = random.Next(2, 24);

            List<(int row, int col)> snakeBody = new List<(int row, int col)>();
            snakeBody.Add((12, 12));
            snakeBody.Add((12, 11));

            while (true)
            {
                foreach (var part in snakeBody)
                {
                    filed[part.row][part.col] = 'x';
                }
                filed[appleX][appleY] = '*';
                DrawField(filed);

                Console.Write("w - верх, s - низ, d - право, a - лево");
                char move = Console.ReadKey().KeyChar;
                move = char.ToLower(move);

                foreach (var part in snakeBody)
                {
                    filed[part.row][part.col] = ' ';
                }

                var head = snakeBody[0];
                (int row, int col) newPosition = head;

                if (move == 'w')
                {
                    newPosition.row--;
                }
                else if (move == 's')
                {
                    newPosition.row++;
                }
                else if (move == 'd')
                {
                    newPosition.col++;
                }
                else if (move == 'a')
                {
                    newPosition.col--;
                }

                if (filed[newPosition.col][newPosition.row] == '#')
                {
                    Console.Clear();
                    Console.WriteLine("=====GAME OVER=====");
                    return;
                }

                snakeBody.Insert(0, newPosition);

                for (int i = 1; i < snakeBody.Count; i++)
                {
                    if (newPosition.row == snakeBody[i].row && newPosition.col == snakeBody[i].col)
                    {
                        Console.Clear();
                        Console.WriteLine("=====GAME OVER=====");
                        return;
                    }
                }

                if (newPosition.row == appleX && newPosition.col == appleY)
                {
                    appleX = random.Next(2, 23);
                    appleY = random.Next(2, 23);
                }
                else
                {
                    snakeBody.RemoveAt(snakeBody.Count - 1);
                }
            }
        }
    }
}