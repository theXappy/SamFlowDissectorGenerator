using System.IO;

namespace SamFlowDissectorGenerator
{
    public static class PathAdv
    {
        /// <summary>
        /// Returns the generated file's path
        /// </summary>
        public static string WriteTempFile(string content, string extension = null)
        {
            string tempFile = Path.GetTempFileName();
            if (extension != null)
            {
                tempFile = Path.ChangeExtension(tempFile, extension);
            }
            File.WriteAllText(tempFile, content);
            return tempFile;
        }
    }
}