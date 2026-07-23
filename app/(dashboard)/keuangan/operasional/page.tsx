import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export default function OperasionalPage() {
  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-3xl font-bold tracking-tight text-primary">Operasional</h2>
        <p className="text-muted-foreground mt-1">
          Manajemen Operasional Bolu Anisa.
        </p>
      </div>
      <Card>
        <CardHeader>
          <CardTitle>Daftar Operasional</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-muted-foreground text-sm">Modul sedang dalam tahap pengembangan berikutnya...</p>
        </CardContent>
      </Card>
    </div>
  );
}