defmodule PrintReactWeb.Api.PrintJobRowsView do
  use PrintReactWeb, :view
  alias PrintReactWeb.Api.PrintJobRowsView
  alias PUP.Models.JobRowModel

  def render("print_job_rows.json", %{print_job_rows: print_job_rows}) do
    render_many(print_job_rows, PrintJobRowsView, "print_job_row.json", as: :print_job_row)
  end

  def render("print_job_row.json", %{print_job_row: %JobRowModel{} = print_job_row}) do
    %{
      startCode: print_job_row.start_code,
      endCode: print_job_row.end_code,
      printerConfigName: print_job_row.printer_config.name,
      state: print_job_row.state,
      pageCount: print_job_row.page_count,
      documentCount: length(print_job_row.documents),
      pagesCompleted: print_job_row.pages_completed
    }
  end
end
