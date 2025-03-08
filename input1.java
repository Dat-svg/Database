import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class input1{

    public static void main(String[] args) {
        try {
            List<String> inputLines = readLines("input1.txt");
            List<String> outputLines = generateOutputLines(inputLines);
            writeOutputFile(outputLines, "output1.txt");

            System.out.println("Tạo file output1.txt thành công.");
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

    private static void writeOutputFile(List<String> lines, String filePath) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        }
    }

    private static List<String> generateOutputLines(List<String> inputLines) {
        List<String> outputLines = new ArrayList<>();

        outputLines.add("Phong ---chaCon--- PhongTieuChuan");
        outputLines.add("Phong ---chaCon--- PhongVIP");
        outputLines.add("PhieuDatPhong(1-1) ---HoaDonDatPhong--- (1,1)HoaDon");
        outputLines.add("HoaDon(1-1) ---thucTheManhYeu--- (1-n)LoaiHoaDon");
        outputLines.add("KhachHang(1-1) ---KhachHangDatPhong--- (1-n)PhieuDatPhong");
        outputLines.add("Phong(n,n) ---DatPhong--- (n,n)PhieuDatPhong");
        outputLines.add("Phong(1,n) ---DichVuKhiDatPhong--- (1,n)DichVu");

        return outputLines;
    }
}
