defmodule IPP.Enums.Groups do
  @groupmap %{
    "job-attributes-tag": ["Job Template", "Job Description"],
    "operation-attributes-tag": "Operation",
    "printer-attributes-tag": "Printer Description",
    "unsupported-attributes-tag": "",
    "subscription-attributes-tag": "Subscription Description",
    "event-notification-attributes-tag": "Event Notifications",
    "resource-attributes-tag": "",
    "document-attributes-tag": "Document Description"
  }

  def get_group(key) do
    Map.get(@groupmap, String.to_atom(key), "")
  end
end

defmodule IPP.Enums do
  alias IPP.Xref

  @enums %{
    "document-state":
      Xref.create(
        Enum.map(0x00..0x02, fn _ -> nil end) ++
          [
            "pending",
            nil,
            "processing",
            nil,
            "canceled",
            "aborted",
            "completed"
          ]
      ),
    finishings:
      Xref.create(
        Enum.map(0x0F..0x13, fn _ -> nil end) ++
          [
            "none",
            "staple",
            "punch",
            "cover",
            "bind",
            "saddle-stitch",
            "edge-stitch",
            "fold",
            "trim",
            "bale",
            "booklet-maker",
            "jog-offset"
          ] ++
          Enum.map(0x20..0x31, fn _ -> nil end) ++
          [
            "staple-top-left",
            "staple-bottom-left",
            "staple-top-right",
            "staple-bottom-right",
            "edge-stitch-left",
            "edge-stitch-top",
            "edge-stitch-right",
            "edge-stitch-bottom",
            "staple-dual-left",
            "staple-dual-top",
            "staple-dual-right",
            "staple-dual-bottom"
          ] ++
          Enum.map(0x36..0x3B, fn _ -> nil end) ++
          [
            "bind-left",
            "bind-top",
            "bind-right",
            "bind-bottom",
            "trim-after-pages",
            "trim-after-documents",
            "trim-after-copies"
          ]
      ),
    "operations-supported":
      Xref.create([
        nil,
        nil,
        "Print-Job",
        "Print-URI",
        "Validate-Job",
        "Create-Job",
        "Send-Document",
        "Send-URI",
        "Cancel-Job",
        "Get-Job-Attributes",
        "Get-Jobs",
        "Get-Printer-Attributes",
        "Hold-Job",
        "Release-Job",
        "Restart-Job",
        nil,
        "Pause-Printer",
        "Resume-Printer",
        "Purge-Jobs",
        "Set-Printer-Attributes",
        "Set-Job-Attributes",
        "Get-Printer-Supported-Values",
        "Create-Printer-Subscriptions",
        "Create-Job-Subscription",
        "Get-Subscription-Attributes",
        "Get-Subscriptions",
        "Renew-Subscription",
        "Cancel-Subscription",
        "Get-Notifications",
        "ipp-indp-method",
        "Get-Resource-Attributes",
        "Get-Resource-Data",
        "Get-Resources",
        "ipp-install",
        "Enable-Printer",
        "Disable-Printer",
        "Pause-Printer-After-Current-Job",
        "Hold-New-Jobs",
        "Release-Held-New-Jobs",
        "Deactivate-Printer",
        "Activate-Printer",
        "Restart-Printer",
        "Shutdown-Printer",
        "Startup-Printer",
        "Reprocess-Job",
        "Cancel-Current-Job",
        "Suspend-Current-Job",
        "Resume-Job",
        "Promote-Job",
        "Schedule-Job-After",
        nil,
        "Cancel-Document",
        "Get-Document-Attributes",
        "Get-Documents",
        "Delete-Document",
        "Set-Document-Attributes",
        "Cancel-Jobs",
        "Cancel-My-Jobs",
        "Resubmit-Job",
        "Close-Job",
        "Identify-Printer",
        "Validate-Document"
      ]),
    "job-collation":
      Xref.create([
        "other",
        "unknown",
        "uncollated-documents",
        "collated-documents",
        "uncollated-documents"
      ]),
    "job-state":
      Xref.create(
        Enum.map(0x00..0x02, fn _ -> nil end) ++
          [
            "pending",
            "pending-held",
            "processing",
            "processing-stopped",
            "canceled",
            "aborted",
            "completed"
          ]
      ),
    "orientation-requested":
      Xref.create(
        Enum.map(0x00..0x02, fn _ -> nil end) ++
          [
            "portrait",
            "landscape",
            "reverse-landscape",
            "reverse-portrait",
            "none"
          ]
      ),
    "print-quality":
      Xref.create(
        Enum.map(0x00..0x02, fn _ -> nil end) ++
          [
            "draft",
            "normal",
            "high"
          ]
      ),
    "printer-state":
      Xref.create(
        Enum.map(0x00..0x02, fn _ -> nil end) ++
          [
            "idle",
            "processing",
            "stopped"
          ]
      ),
    "finishings-default":
      Xref.create(
        Enum.map(0x0F..0x13, fn _ -> nil end) ++
          [
            "none",
            "staple",
            "punch",
            "cover",
            "bind",
            "saddle-stitch",
            "edge-stitch",
            "fold",
            "trim",
            "bale",
            "booklet-maker",
            "jog-offset"
          ] ++
          Enum.map(0x20..0x31, fn _ -> nil end) ++
          [
            "staple-top-left",
            "staple-bottom-left",
            "staple-top-right",
            "staple-bottom-right",
            "edge-stitch-left",
            "edge-stitch-top",
            "edge-stitch-right",
            "edge-stitch-bottom",
            "staple-dual-left",
            "staple-dual-top",
            "staple-dual-right",
            "staple-dual-bottom"
          ] ++
          Enum.map(0x36..0x3B, fn _ -> nil end) ++
          [
            "bind-left",
            "bind-top",
            "bind-right",
            "bind-bottom",
            "trim-after-pages",
            "trim-after-documents",
            "trim-after-copies"
          ]
      ),
    "finishings-ready":
      Xref.create(
        Enum.map(0x0F..0x13, fn _ -> nil end) ++
          [
            "none",
            "staple",
            "punch",
            "cover",
            "bind",
            "saddle-stitch",
            "edge-stitch",
            "fold",
            "trim",
            "bale",
            "booklet-maker",
            "jog-offset"
          ] ++
          Enum.map(0x20..0x31, fn _ -> nil end) ++
          [
            "staple-top-left",
            "staple-bottom-left",
            "staple-top-right",
            "staple-bottom-right",
            "edge-stitch-left",
            "edge-stitch-top",
            "edge-stitch-right",
            "edge-stitch-bottom",
            "staple-dual-left",
            "staple-dual-top",
            "staple-dual-right",
            "staple-dual-bottom"
          ] ++
          Enum.map(0x36..0x3B, fn _ -> nil end) ++
          [
            "bind-left",
            "bind-top",
            "bind-right",
            "bind-bottom",
            "trim-after-pages",
            "trim-after-documents",
            "trim-after-copies"
          ]
      ),
    "finishings-supported":
      Xref.create(
        Enum.map(0x0F..0x13, fn _ -> nil end) ++
          [
            "none",
            "staple",
            "punch",
            "cover",
            "bind",
            "saddle-stitch",
            "edge-stitch",
            "fold",
            "trim",
            "bale",
            "booklet-maker",
            "jog-offset"
          ] ++
          Enum.map(0x20..0x31, fn _ -> nil end) ++
          [
            "staple-top-left",
            "staple-bottom-left",
            "staple-top-right",
            "staple-bottom-right",
            "edge-stitch-left",
            "edge-stitch-top",
            "edge-stitch-right",
            "edge-stitch-bottom",
            "staple-dual-left",
            "staple-dual-top",
            "staple-dual-right",
            "staple-dual-bottom"
          ] ++
          Enum.map(0x36..0x3B, fn _ -> nil end) ++
          [
            "bind-left",
            "bind-top",
            "bind-right",
            "bind-bottom",
            "trim-after-pages",
            "trim-after-documents",
            "trim-after-copies"
          ]
      ),
    "media-source-feed-orientation":
      Xref.create(
        Enum.map(0x00..0x02, fn _ -> nil end) ++
          [
            "portrait",
            "landscape",
            "reverse-landscape",
            "reverse-portrait",
            "none"
          ]
      ),
    "orientation-requested-default":
      Xref.create(
        Enum.map(0x00..0x02, fn _ -> nil end) ++
          [
            "portrait",
            "landscape",
            "reverse-landscape",
            "reverse-portrait",
            "none"
          ]
      ),
    "orientation-requested-supported":
      Xref.create(
        Enum.map(0x00..0x02, fn _ -> nil end) ++
          [
            "portrait",
            "landscape",
            "reverse-landscape",
            "reverse-portrait",
            "none"
          ]
      ),
    "print-quality-default":
      Xref.create(
        Enum.map(0x00..0x02, fn _ -> nil end) ++
          [
            "draft",
            "normal",
            "high"
          ]
      ),
    "print-quality-supported":
      Xref.create(
        Enum.map(0x00..0x02, fn _ -> nil end) ++
          [
            "draft",
            "normal",
            "high"
          ]
      )
  }

  def get_enum(key, group) when is_bitstring(key) do
    @enums[group][key]
  end

  def get_enum(key, group) do
    map = Map.get(@enums, String.to_atom(group))

    if is_nil(map) do
      ""
    else
      map
      |> Map.get(:lookup)
      |> Enum.at(key, "")
    end
  end

  def get, do: @enums
end

defmodule IPP.Enums.Versions do
  @versions %{
    "1.0": 0x0100,
    "1.1": 0x0101,
    "2.0": 0x0200,
    "2.1": 0x0201,
    "#{0x0100}": "1.0",
    "#{0x0101}": "1.1",
    "#{0x0200}": "2.0",
    "#{0x0201}": "2.1"
  }

  def get(key) do
    if is_bitstring(key) do
      Map.get(@versions, key, 0x0201)
    else
      Map.get(@versions, "#{key}", "2.1")
    end
  end
end
