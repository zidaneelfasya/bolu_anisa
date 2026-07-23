import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export default function LaporanPage() {
  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-3xl font-bold tracking-tight text-primary">Laporan</h2>
        <p className="text-muted-foreground mt-1">
          Manajemen Laporan Bolu Anisa.
        </p>
      </div>
      <Card>
        <CardHeader>
          <CardTitle>Daftar Laporan</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground text-sm">Modul sedang dalam tahap pengembangan berikutnya...</p>
        </CardContent>
      </Card>
    </div>
  );
}