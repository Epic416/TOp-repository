namespace aaaaa
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("ВИСЕЛИЦА");

            int attempts = 10;

            Console.Write("Загадай слово: ");
            string word = Console.ReadLine().ToUpper();
            Console.Clear();

            string guessedLetters = "";

            while (true)
            {
                if (attempts == 0)
                {
                    Console.WriteLine("Ты проиграл!");
                    Console.WriteLine("Слово было: " + word);
                    break;
                }

                bool wordGuessed = true;
                Console.Write("Слово: ");
                foreach (char c in word)
                {
                    if (guessedLetters.Contains(c))
                        Console.Write(c + " ");
                    else
                    {
                        Console.Write("_ ");
                        wordGuessed = false;
                    }
                }

                if (wordGuessed)
                {
                    Console.WriteLine("\n\nТы выиграл!");
                    break;
                }

                Console.WriteLine("\n\nОсталось попыток: " + attempts);
                Console.WriteLine("Использованные буквы: " + guessedLetters);
                Console.Write("Введи букву: ");

                string letter = Console.ReadLine().ToUpper();

                if (letter.Length == 0) continue;

                char letterChar = letter[0];

                if (guessedLetters.Contains(letterChar))
                {
                    Console.WriteLine("Ты уже вводил эту букву!");
                    continue;
                }

                if (word.Contains(letterChar))
                {
                    Console.WriteLine("Есть такая буква!");
                    guessedLetters += letterChar;
                }
                else
                {
                    Console.WriteLine("Нет такой буквы!");
                    attempts--;
                }

                Console.WriteLine();
            }
        }
    }
}