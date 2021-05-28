defmodule PUP.Models.ConfigModel do
  @enforce_keys [:name, :form_type]
  defstruct name: "", form_type: "", printers: []
end

defmodule PUP.Models.JobRowModel do
  alias PUP.Models.{ConfigModel, DocumentMeta, JobRowModel}

  @enforce_keys [:start_code, :page_count, :documents, :printer_config]
  defstruct start_code: "",
            end_code: "",
            state: "Ready",
            page_count: 0,
            pages_completed: 0,
            documents: [],
            printer_config: %ConfigModel{name: "", form_type: ""}

  def from(opts) do
    docs_and_page_count_map = DocumentMeta.from(opts.documents)

    opts =
      Map.merge(opts, docs_and_page_count_map)
      |> Map.put(:printer_config, %ConfigModel{
        name: "p1",
        form_type: "YearEnd",
        printers:
          Enum.map(1..(:rand.uniform(6) + 6), fn i ->
            "#{opts.start_code}-printer#{i}"
          end)
      })

    struct(JobRowModel, opts)
  end

  def update(_row_model) do
  end
end

defmodule PUP.Models.DocumentMeta do
  alias PUP.Models.DocumentMeta

  @enforce_keys [:code, :doc_path, :page_count]
  defstruct code: "", doc_path: "", page_count: 0, page_range: [0, 0]

  def from(list) when is_list(list) do
    base = %{documents: [], page_count: 0}

    Enum.reduce(list, base, fn opts, acc ->
      %{
        documents: docs,
        page_count: total
      } = acc

      doc = %DocumentMeta{
        page_count: opts["pageCount"],
        code: opts["code"],
        doc_path: opts["docPath"]
      }

      %{documents: [doc | docs], page_count: total + opts["pageCount"]}
    end)
  end
end
