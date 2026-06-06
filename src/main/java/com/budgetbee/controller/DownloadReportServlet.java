package com.budgetbee.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.budgetbee.dao.ExpenseDAO;
import com.budgetbee.dao.IncomeDAO;
import com.budgetbee.model.Expense;
import com.budgetbee.model.Income;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.awt.Color;

@WebServlet("/downloadReport")
public class DownloadReportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        IncomeDAO  incomeDAO  = new IncomeDAO();
        ExpenseDAO expenseDAO = new ExpenseDAO();

        double totalIncome  = incomeDAO.getTotalIncome();
        double totalExpense = expenseDAO.getTotalExpense();
        double savings      = totalIncome - totalExpense;
        double savingsRate  = totalIncome > 0 ?
                (savings * 100) / totalIncome : 0;

        List<Income>  incomeList  = incomeDAO.getAllIncome();
        List<Expense> expenseList = expenseDAO.getAllExpenses();

        String generatedDate = LocalDate.now()
                .format(DateTimeFormatter.ofPattern("dd MMM yyyy"));

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=Cashio_Report.pdf");

        Document document = new Document(PageSize.A4, 36, 36, 54, 36);

        try {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // ── Fonts ──────────────────────────────────────
            Font titleFont = FontFactory.getFont(
                    FontFactory.HELVETICA_BOLD, 22,
                    new Color(11, 31, 58));

            Font subtitleFont = FontFactory.getFont(
                    FontFactory.HELVETICA, 11,
                    new Color(100, 100, 100));

            Font sectionFont = FontFactory.getFont(
                    FontFactory.HELVETICA_BOLD, 13,
                    new Color(11, 31, 58));

            Font normalFont = FontFactory.getFont(
                    FontFactory.HELVETICA, 11,
                    Color.BLACK);

            Font boldFont = FontFactory.getFont(
                    FontFactory.HELVETICA_BOLD, 11,
                    Color.BLACK);

            Font greenFont = FontFactory.getFont(
                    FontFactory.HELVETICA_BOLD, 11,
                    new Color(40, 167, 69));

            Font redFont = FontFactory.getFont(
                    FontFactory.HELVETICA_BOLD, 11,
                    new Color(220, 53, 69));

            Font tableHeaderFont = FontFactory.getFont(
                    FontFactory.HELVETICA_BOLD, 10,
                    Color.WHITE);

            Font tableCellFont = FontFactory.getFont(
                    FontFactory.HELVETICA, 10,
                    Color.BLACK);

            // ── Header ─────────────────────────────────────
            Paragraph title = new Paragraph(
                    "Cashio Financial Report", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            Paragraph date = new Paragraph(
                    "Generated on: " + generatedDate, subtitleFont);
            date.setAlignment(Element.ALIGN_CENTER);
            date.setSpacingAfter(20);
            document.add(date);

            // ── Divider line ───────────────────────────────
            PdfPTable divider = new PdfPTable(1);
            divider.setWidthPercentage(100);
            PdfPCell divCell = new PdfPCell();
            divCell.setBackgroundColor(new Color(11, 31, 58));
            divCell.setFixedHeight(3);
            divCell.setBorder(Rectangle.NO_BORDER);
            divider.addCell(divCell);
            divider.setSpacingAfter(20);
            document.add(divider);

            // ── Summary Section ────────────────────────────
            Paragraph summaryTitle = new Paragraph(
                    "Financial Summary", sectionFont);
            summaryTitle.setSpacingAfter(10);
            document.add(summaryTitle);

            PdfPTable summaryTable = new PdfPTable(2);
            summaryTable.setWidthPercentage(60);
            summaryTable.setHorizontalAlignment(Element.ALIGN_LEFT);
            summaryTable.setWidths(new float[]{50f, 50f});
            summaryTable.setSpacingAfter(25);

            addSummaryRow(summaryTable,
                    "Total Income",
                    "Rs. " + String.format("%.2f", totalIncome),
                    new Color(232, 245, 233), greenFont, normalFont);

            addSummaryRow(summaryTable,
                    "Total Expense",
                    "Rs. " + String.format("%.2f", totalExpense),
                    new Color(255, 235, 238), redFont, normalFont);

            addSummaryRow(summaryTable,
                    "Net Savings",
                    "Rs. " + String.format("%.2f", savings),
                    new Color(227, 242, 253),
                    savings >= 0 ? greenFont : redFont, normalFont);

            addSummaryRow(summaryTable,
                    "Savings Rate",
                    String.format("%.1f", savingsRate) + "%",
                    new Color(243, 229, 245),
                    savingsRate >= 0 ? greenFont : redFont, normalFont);

            document.add(summaryTable);

            // ── Income Table ───────────────────────────────
            Paragraph incomeTitle = new Paragraph(
                    "Income Transactions", sectionFont);
            incomeTitle.setSpacingAfter(10);
            document.add(incomeTitle);

            PdfPTable incomeTable = new PdfPTable(4);
            incomeTable.setWidthPercentage(100);
            incomeTable.setWidths(new float[]{10f, 30f, 35f, 25f});
            incomeTable.setSpacingAfter(25);

            // Header row
            addTableHeader(incomeTable,
                    new String[]{"#", "Source",
                            "Description", "Amount"},
                    new Color(11, 31, 58), tableHeaderFont);

            // Data rows
            if (incomeList != null && !incomeList.isEmpty()) {
                int count = 1;
                for (Income inc : incomeList) {
                    Color rowColor = count % 2 == 0 ?
                            new Color(245, 245, 245) : Color.WHITE;

                    addTableCell(incomeTable,
                            String.valueOf(count),
                            rowColor, tableCellFont,
                            Element.ALIGN_CENTER);
                    addTableCell(incomeTable,
                            inc.getSource(),
                            rowColor, tableCellFont,
                            Element.ALIGN_LEFT);
                    addTableCell(incomeTable,
                            inc.getDescription() != null ?
                            inc.getDescription() : "-",
                            rowColor, tableCellFont,
                            Element.ALIGN_LEFT);
                    addTableCell(incomeTable,
                            "Rs. " + String.format(
                                    "%.2f", inc.getAmount()),
                            rowColor, greenFont,
                            Element.ALIGN_RIGHT);
                    count++;
                }
            } else {
                PdfPCell noData = new PdfPCell(
                        new Phrase("No income records found",
                                normalFont));
                noData.setColspan(4);
                noData.setHorizontalAlignment(Element.ALIGN_CENTER);
                noData.setPadding(10);
                incomeTable.addCell(noData);
            }

            document.add(incomeTable);

            // ── Expense Table ──────────────────────────────
            Paragraph expenseTitle = new Paragraph(
                    "Expense Transactions", sectionFont);
            expenseTitle.setSpacingAfter(10);
            document.add(expenseTitle);

            PdfPTable expenseTable = new PdfPTable(4);
            expenseTable.setWidthPercentage(100);
            expenseTable.setWidths(new float[]{10f, 30f, 35f, 25f});
            expenseTable.setSpacingAfter(25);

            // Header row
            addTableHeader(expenseTable,
                    new String[]{"#", "Category",
                            "Description", "Amount"},
                    new Color(180, 30, 30), tableHeaderFont);

            // Data rows
            if (expenseList != null && !expenseList.isEmpty()) {
                int count = 1;
                for (Expense exp : expenseList) {
                    Color rowColor = count % 2 == 0 ?
                            new Color(245, 245, 245) : Color.WHITE;

                    addTableCell(expenseTable,
                            String.valueOf(count),
                            rowColor, tableCellFont,
                            Element.ALIGN_CENTER);
                    addTableCell(expenseTable,
                            exp.getCategory(),
                            rowColor, tableCellFont,
                            Element.ALIGN_LEFT);
                    addTableCell(expenseTable,
                            exp.getDescription() != null ?
                            exp.getDescription() : "-",
                            rowColor, tableCellFont,
                            Element.ALIGN_LEFT);
                    addTableCell(expenseTable,
                            "Rs. " + String.format(
                                    "%.2f", exp.getAmount()),
                            rowColor, redFont,
                            Element.ALIGN_RIGHT);
                    count++;
                }
            } else {
                PdfPCell noData = new PdfPCell(
                        new Phrase("No expense records found",
                                normalFont));
                noData.setColspan(4);
                noData.setHorizontalAlignment(Element.ALIGN_CENTER);
                noData.setPadding(10);
                expenseTable.addCell(noData);
            }

            document.add(expenseTable);

            // ── Footer ─────────────────────────────────────
            PdfPTable footer = new PdfPTable(1);
            footer.setWidthPercentage(100);
            PdfPCell footerCell = new PdfPCell(
                    new Phrase("Generated by Cashio  •  " +
                            generatedDate, subtitleFont));
            footerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            footerCell.setBorder(Rectangle.TOP);
            footerCell.setPaddingTop(10);
            footer.addCell(footerCell);
            document.add(footer);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            document.close();
        }
    }

    // ── Helper: Summary row ────────────────────────────────
    private void addSummaryRow(PdfPTable table,
            String label, String value,
            Color bgColor, Font valueFont, Font labelFont) {

        PdfPCell labelCell = new PdfPCell(
                new Phrase(label, labelFont));
        labelCell.setBackgroundColor(bgColor);
        labelCell.setPadding(10);
        labelCell.setBorderColor(new Color(220, 220, 220));

        PdfPCell valueCell = new PdfPCell(
                new Phrase(value, valueFont));
        valueCell.setBackgroundColor(bgColor);
        valueCell.setPadding(10);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        valueCell.setBorderColor(new Color(220, 220, 220));

        table.addCell(labelCell);
        table.addCell(valueCell);
    }

    // ── Helper: Table header ───────────────────────────────
    private void addTableHeader(PdfPTable table,
            String[] headers, Color bgColor, Font font) {

        for (String header : headers) {
            PdfPCell cell = new PdfPCell(
                    new Phrase(header, font));
            cell.setBackgroundColor(bgColor);
            cell.setPadding(10);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setBorderColor(new Color(200, 200, 200));
            table.addCell(cell);
        }
    }

    // ── Helper: Table cell ─────────────────────────────────
    private void addTableCell(PdfPTable table,
            String text, Color bgColor,
            Font font, int alignment) {

        PdfPCell cell = new PdfPCell(
                new Phrase(text, font));
        cell.setBackgroundColor(bgColor);
        cell.setPadding(8);
        cell.setHorizontalAlignment(alignment);
        cell.setBorderColor(new Color(220, 220, 220));
        table.addCell(cell);
    }
}