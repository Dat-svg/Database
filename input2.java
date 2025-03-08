import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class input2{

    public static void main(String[] args) {
        try {
            List<String> lines = readLines("input2.txt");
            List<String> outputLines = processInputData(lines);
            writeLines(outputLines, "output2.txt");

            System.out.println("Xử lý thành công.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static List<String> readLines(String filePath) throws IOException {
        List<String> lines = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                lines.add(line);
            }
        }
        return lines;
    }

    private static void writeLines(List<String> lines, String filePath) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        }
    }

    private static List<String> processInputData(List<String> inputLines) {
        List<String> outputLines = new ArrayList<>();
        Map<String, List<String>> entityAttributes = new HashMap<>();
        List<String> relationships = new ArrayList<>();

        String currentEntity = "";

        for (String line : inputLines) {
            if (line.startsWith("[") && line.endsWith("]")) {
                currentEntity = line.substring(1, line.length() - 1).trim();
                entityAttributes.put(currentEntity, new ArrayList<>());
            } else if (!line.isEmpty()) {
                if (line.contains("->")) {
                    relationships.add(line.trim());
                } else {
                    entityAttributes.get(currentEntity).add(line.trim());
                }
            }
        }

        String entityName = "PhieuDatPhong";
        outputLines.add("Bao đóng của tập thuộc tính PhieuDatPhong " + entityName + ": " +
                entityAttributes.get(entityName).toString());

        outputLines.add("\nKhóa của các quan hệ:");
        for (Map.Entry<String, List<String>> entry : entityAttributes.entrySet()) {
            String entity = entry.getKey();
            List<String> attributes = entry.getValue();

            String attributesString = attributes.stream()
                    .map(attr -> attributes.size() > 1 && attr.equals(entity) ? "(" + attr + ")" : attr)
                    .collect(Collectors.joining(", "));

            outputLines.add(entity + ": " + attributesString);
        }
        return outputLines;
    }
}
