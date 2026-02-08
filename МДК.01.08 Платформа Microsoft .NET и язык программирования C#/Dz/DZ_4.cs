namespace ConsoleApp2
{
    internal class Program
    {
        static void Main(string[] args)
        {
            //1
            List<string> fruits = new List<string>{"apple", "orange", "pineapple", "melon", "banana"};
            fruits.RemoveAt(fruits.IndexOf("pineapple"));
            foreach (var n in fruits)
            {
                Console.Write(n, " ");
            }
            Console.WriteLine();

            //2
            string[] names = { "Anna", "Nick", "Larry", "Alex", "Louis" };
            bool containsName = names.Contains("Alex");
            if(containsName)
            {
                Console.WriteLine("True");
            }

            //3
            int[] nums = { 1, 3, 2, 3, 3 };
            int summ = 0;
            foreach( var n in nums)
            {
                summ += n;
            }
            Console.WriteLine(summ);

            //4
            int[] numbers = new int[10];
            int[] squares = new int[10];
            int[] cubes = new int[10];
            for (int i = 0; i < 10; i++)
            {
                numbers[i] = i + 1;
                squares[i] = numbers[i] * numbers[i];
                cubes[i] = numbers[i] * numbers[i] * numbers[i];
            }
            Console.WriteLine();
            for (int i = 0; i < 10; i++)
            {
                Console.Write(numbers[i] + " ");
            }
            Console.WriteLine();
            for (int i = 0; i < 10; i++)
            {
                Console.Write(squares[i] + " ");
            }
            Console.WriteLine();
            for (int i = 0; i < 10; i++)
            {
                Console.Write(cubes[i] + " ");
            }
        }
    }
}
